#!/usr/bin/python3

import socket, time

charName = ""
totalItemsSent = 0
itemsToSendCount = 0
itemsToSend = ""

itemEnchantMapping = {
    "2669": "35456",
    "2650": "35441 35425", #
    "2671": "35462",
    "2672": "35460",
    "2673": "35458",
    "2930": "35444",
    "2658": "35418",
    "2929": "35447",
    "2928": "35445",
    "1888": "35450",
    "2670": "35396",
    "2674": "35461",
    "2675": "35452",
    "2935": "35443",
    "2937": "35441",
    "2939": "35399",
    "2940": "35398",
    "2649": "35421 35417", #
    "2667": "35397",
    "2668": "35459",
    "2322": "35440",
    "1257": "35433",
    "1441": "35434",
    "2343": "35454",
    "2661": "35429",
    "2933": "35430",
    "2655": "35451",
    "2657": "35400",
    "963": "35457",
    "2666": "35455",
    "684": "35442",
    "2679": "35424",
    "2664": "35435",
    "3229": "187783",
    "2617": "35427",
    "2654": "35448",
    "2938": "35436",
    "1071": "35449",
    "2648": "35422",
    "1144": "35431",
    "1891": "35426",
    "2659": "35428",
    "2662": "35437",
    "1594": "35438",
    "368": "35432",
    "2647": "35420",
    "2656": "35419",
    "2934": "35439",
    "369": "35423",
    "2613": "187801",
    "2564": "187739",
    "2619": "187815",
    "2620": "187807",
    "910": "187738",
    "2621": "187800",
    "1593": "187737",
    "2748": "24274",
    "2724": "23766",
    "2746": "24276",
    "3012": "29535",
    "3013": "29536",
    "2723": "23765",
    "3002": "29191",
    "3009": "29199",
    "3269": "34836",
    "2986": "28888",
    "2998": "29187",
    "2714": "23530",
    "2982": "28886",
    "2999": "29186",
    "2980": "28887",
    "2995": "28909",
    "3001": "29190",
    "2841": "34330",
    "2978": "28889",
    "2997": "28910",
    "3006": "29195",
    "3008": "29198",
    "3007": "29197",
    "2991": "28911",
    "3005": "29194",
    "2993": "28912",
    "3096": "30846",
    "3260": "34207",
    "3004": "29193",
    "3095": "30845",
    "3000": "29188",
    "2984": "29483",
    "2985": "29485",
    "2987": "29486",
    "2989": "29488",
    "2988": "29487",
    "2747": "24273",
    "3010": "29533",
    "3011": "29534",
    "2745": "24275",
    "2722": "23764",
    "2793": "25651",
    "2794": "25652",
    "2979": "28878",
    "2981": "28881",
    "2983": "28885",
    "2990": "28908",
    "2994": "28903",
    "2996": "28907",
    "2977": "28882",
    "2992": "28904",
    "3223": "33185",
    "2683": "22638",
    "2717": "23548",
    "2721": "23545",
    "2523": "18283",
    "2583": "19782",
    "2715": "23547",
    "2792": "25650",
    "2605": "20076",
    "2716": "23549",
    "2487": "18173",
    "2606": "20077",
    "2604": "20078",
    "2681": "22635",
    "2587": "19786",
    "2590": "19789",
    "2586": "19785",
    "2488": "18182",
    "2589": "19788",
    "2588": "19787",
    "2584": "19783",
    "2585": "19784",
    "2483": "18169",
    "2682": "22636",
    "2485": "18171",
    "2591": "19790",
    "2503": "18251",
    "2484": "18170",
    "2486": "18172",
    "3003": "29192",
    "2646": "35396"
}


def addItem(itemToSend):
    global itemsToSend, itemsToSendCount, charName, totalItemsSent
    itemsToSend += itemToSend
    itemsToSend += " "
    itemsToSendCount += 1
    totalItemsSent += 1
    #print (itemToSend)
    #print (itemsToSend)
    #print(int(itemsToSendCount))
    if (itemsToSendCount == 12):
        #print(itemsToSend)
        sendItems("192.168.1.240", 3443, charName, itemsToSend)
        itemsToSendCount = 0
        itemsToSend = ""


def sendItems(host, port, name, items):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((host, int(port)))
    while True:
        data = s.recv(4096)
        if "Username:" in str(data):
            #print(repr(data))
            time.sleep(.1)
            s.send('jarp\n'.encode())
        if "Password:" in str(data):
            #print(repr(data))
            time.sleep(.1)
            s.send('jarp123notrealbtw\n'.encode())
        if "mangos>" in str(data):
            #print(repr(data))
            time.sleep(.1)
            command = 'send items ' + name + ' \"Gear\" \"Merry Christmas ya filthy animal\" ' + items + '\n'
            print(command)
            #s.send(command.encode())
            time.sleep(.1)
            break
        if not data:
            break
        #print(repr(data))
    s.close()


def readCharDump(charDumpFile):
    global charName
    
    lines = []
    with open(charDumpFile) as f:
        lines = f.readlines()

    for line in lines:
        if line.startswith('name'):
            charName = (line.split(':')[1]).strip()
        elif line.startswith('##itemName'):
            line = line.lstrip("#")
            itemInfo = (line.split(';'))
            if itemInfo:
                itemName = (itemInfo[0]).split(':')[1].strip()
                itemId = (itemInfo[1]).split(':')[1].strip()
                enchantId = (itemInfo[2]).split(':')[1].strip()
                gem1Id = (itemInfo[3]).split(':')[1].strip()
                gem2Id = (itemInfo[4]).split(':')[1].strip()
                gem3Id = (itemInfo[5]).split(':')[1].strip()
                gem4Id = (itemInfo[6]).split(':')[1].strip()
                suffixId = (itemInfo[7]).split(':')[1].strip()
                itemCount = (itemInfo[8]).split(':')[1].strip()
                # if itemName:
                    # print(itemName)
                if itemId:
                    if (itemCount != '1'):
                        itemId = itemId + ":" + itemCount
                    addItem(itemId)

                if enchantId:
                    if enchantId in itemEnchantMapping:
                        enchantItem = itemEnchantMapping[enchantId]
                        if ' ' in enchantItem:
                            enchantItemList = enchantItem.split(' ')
                            for splitEnchantItem in enchantItemList:
                                addItem(splitEnchantItem)
                        else:
                            addItem(enchantItem)
                    else:
                        print("enchantId provided does not map to useable enchant item: " + enchantId)
                if gem1Id:
                    addItem(gem1Id)
                if gem2Id:
                    addItem(gem2Id)
                if gem3Id:
                    addItem(gem3Id)
                if gem4Id:
                    addItem(gem4Id)
                # if suffixId:
                    # print(suffixId)
                # if (itemCount != '1'):
                    # print(itemCount)
    print('Sent ' + str(totalItemsSent) + ' items in the mail to ' + str(charName))

if __name__ == '__main__':
    readCharDump('charinfo.txt')

# enchantId = "2649"
# enchantItem = itemEnchantMapping[enchantId]
# if ' ' in enchantItem:
#     enchantItemList = enchantItem.split(' ')
#     for splitEnchantItem in enchantItemList:
#         print(splitEnchantItem)

# print(enchantItem)