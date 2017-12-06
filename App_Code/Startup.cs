using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(BookmarkIT.Startup))]
namespace BookmarkIT
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
