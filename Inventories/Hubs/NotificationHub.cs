using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Inventories.Hubs
{
    [HubName("NotificationHub")]
    public class NotificationHub : Hub
    {
        public static void BroadcastData()
        {

            IHubContext context = GlobalHost.ConnectionManager.GetHubContext<NotificationHub>();
            context.Clients.All.refreshNotificationData();
            //Clients.All.hello();
        }
    }
}