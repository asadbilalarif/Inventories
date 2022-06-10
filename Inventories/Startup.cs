using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(Inventories.Startup))]

namespace Inventories
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}

