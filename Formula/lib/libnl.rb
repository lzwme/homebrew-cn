class Libnl < Formula
  desc "Netlink Library Suite"
  homepage "https://github.com/thom311/libnl"
  url "https://ghproxy.com/https://github.com/thom311/libnl/releases/download/libnl3_9_0/libnl-3.9.0.tar.gz"
  sha256 "aed507004d728a5cf11eab48ca4bf9e6e1874444e33939b9d3dfed25018ee9bb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 x86_64_linux: "07804611bd9c14d970bba5b051a54e71045331061861dc1a9c128ef5ab6d80ca"
  end

  depends_on "pkg-config" => :test
  depends_on :linux # Netlink sockets are only available in Linux.

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <netlink/netlink.h>
      #include <netlink/route/link.h>

      #include <linux/netlink.h>

      int main(int argc, char *argv[])
      {
        struct rtnl_link *link;
        struct nl_sock *sk;
        int err;

        sk = nl_socket_alloc();
        if ((err = nl_connect(sk, NETLINK_ROUTE)) < 0) {
          nl_perror(err, "Unable to connect socket");
          return err;
        }

        link = rtnl_link_alloc();
        rtnl_link_set_name(link, "my_bond");

        if ((err = rtnl_link_delete(sk, link)) < 0) {
          nl_perror(err, "Unable to delete link");
          return err;
        }

        rtnl_link_put(link);
        nl_close(sk);

        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs libnl-3.0 libnl-route-3.0").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match "Unable to delete link: Operation not permitted", shell_output("#{testpath}/test 2>&1", 228)

    assert_match "inet 127.0.0.1", shell_output("#{bin}/nl-route-list")
  end
end