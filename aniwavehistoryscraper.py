# THIS TOOL NO LONGER WORKS; AS ANIWAVE HAS FULLY SHUTDOWN

import requests
from bs4 import BeautifulSoup
import time
import json

funny_aniwave_session = "" 
u = "https://aniwave.to/user/continue-watching?page="
c = {"session": funny_aniwave_session}
d = 2
f = "history.json"
a = []
p = 1

while True:
    print(f"\nScraping history of page {p}...")
    try:
        r = requests.get(f"{u}{p}", cookies=c)
        time.sleep(d)

        if r.status_code == 200:
            s = BeautifulSoup(r.text, 'html.parser')

            auser = s.find('div', class_='name')
            if auser:
                auser = auser.get_text(strip=True)
                print(f"Logged in as {auser}")
            else:
                print("Could not find user information.")
                auser = "Unknown"

            t = s.find_all('a', class_='name d-title')

            if not t:
                print("Seems like this is the last page, stopping and saving data to history.json")
                break

            i = s.find_all('img', alt=True)

            for idx, title in enumerate(t):
                n = title.get_text(strip=True)
                jn = title.get('data-jp', '').strip()
                e = (title.find_next('div', class_='left') or '').get_text(strip=True)
                ts = (title.find_next('div', class_='right') or '').get_text(strip=True)
                th = i[idx]['src'] if idx < len(i) else ''

                print(f"Page: {p}")
                print(f"Name: {n}")
                print(f"Japanese Name: {jn}")
                print(f"Episode: {e}")
                print(f"Timestamp: {ts}")
                print(f"Thumbnail: {th}")

                if th:
                    img_r = requests.get(th)
                    time.sleep(d)
                    if img_r.status_code == 200:
                        with open(f"{n.replace(' ', '-')}.png", 'wb') as img_f:
                            img_f.write(img_r.content)
                        print(f"Saved image:  {n.replace(' ', '-')}.png\n")
                    else:
                        print(f"Failed to save image from {th}\n")

                a.append({
                    "page": p,
                    "name": n,
                    "japanese_name": jn,
                    "episode": e,
                    "timestamp": ts,
                    "thumbnail": th
                })
                time.sleep(d)

            p += 1
        else:
            print("Seems like this is the last page, stopping and saving data to history.json")
            break
    except Exception as e:
        print(f"An error occurred: {e}")
        print("Seems like this is the last page, stopping and saving data to history.json")
        break

with open(f, 'w', encoding='utf-8') as out_f:
    json.dump(a, out_f, ensure_ascii=False, indent=4)
print(f"Information scraped has been saved to {f}")
