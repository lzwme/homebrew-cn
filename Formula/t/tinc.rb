class Tinc < Formula
  desc "Virtual Private Network (VPN) tool"
  homepage "https:www.tinc-vpn.org"
  url "https:tinc-vpn.orgpackagestinc-1.0.36.tar.gz"
  sha256 "40f73bb3facc480effe0e771442a706ff0488edea7a5f2505d4ccb2aa8163108"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https:www.tinc-vpn.orgdownload"
    regex(href=.*?tinc[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "d452247fec1d29690250c77dafdeb7cac2c945ddef7f11e19fa728563cf4f720"
    sha256 cellar: :any,                 arm64_sonoma:   "ab60d88c2bb9f1d867bc7fad3ff18086c3bb907502cc1f9af3c61eab5c633771"
    sha256 cellar: :any,                 arm64_ventura:  "9f2467372c458402453d111b49be9ebdfb5d7e53f1a3a33d32bf2c43e9cd6b1b"
    sha256 cellar: :any,                 arm64_monterey: "4fb0f6f2276a92f60c5aad1674c137850d6e0a6ac77adc8ce575aa4288a8b942"
    sha256 cellar: :any,                 arm64_big_sur:  "88d77dd06ee97bf7c1cc0e330876c992d7d460cc55e8e62ebb5c03a0f4ebb0e2"
    sha256 cellar: :any,                 sonoma:         "dfbaa4b890c987e2daeb4a38a4a82d8008ad23e38b135768909c9eeda980c2ff"
    sha256 cellar: :any,                 ventura:        "3f2730126370c8ded288e13b4756426213aef4082039f8a7b64776214ce70db6"
    sha256 cellar: :any,                 monterey:       "58d69be546dceda9a4d413770531633c132cf46a5901553f3d0367cd0bae282f"
    sha256 cellar: :any,                 big_sur:        "094208fa2043d75696fa60b47a4d26f32e67fbffcce78cc37429a6eac641ddb8"
    sha256 cellar: :any,                 catalina:       "878a5d0ded29f6b9ad6a18e040508e7597551d4b359c39f9ecaaa7fc6cb91b12"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "66115eb9b72b5609f201efb79752275a5d166d530e538689d3770ad51e8a33e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1cf23e958fe70fd7662d67e87ab9adfd4d838550b104216ec70363391ec7595"
  end

  depends_on "lzo"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  # fix build errors, upstream pr ref, https:github.comgsliepentincpull464
  patch :DATA

  def install
    system ".configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  def post_install
    (var"runtinc").mkpath
  end

  service do
    run [opt_sbin"tincd", "--config=#{etc}tinc", "--pidfile=#{var}runtinctinc.pid", "-D"]
    keep_alive true
    require_root true
    working_dir etc"tinc"
    log_path var"logtincstdout.log"
    error_log_path var"logtincstderr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}tincd --version")
  end
end

__END__
diff --git asrcnet_socket.c bsrcnet_socket.c
index 6195c16..e072970 100644
--- asrcnet_socket.c
+++ bsrcnet_socket.c
@@ -102,14 +102,14 @@ static bool bind_to_interface(int sd) {

 #if defined(SOL_SOCKET) && defined(SO_BINDTODEVICE)
 	memset(&ifr, 0, sizeof(ifr));
-	strncpy(ifr.ifr_ifrn.ifrn_name, iface, IFNAMSIZ);
-	ifr.ifr_ifrn.ifrn_name[IFNAMSIZ - 1] = 0;
+	strncpy(ifr.ifr_name, iface, IFNAMSIZ);
+	ifr.ifr_name[IFNAMSIZ - 1] = 0;
 	free(iface);

 	status = setsockopt(sd, SOL_SOCKET, SO_BINDTODEVICE, (void *)&ifr, sizeof(ifr));

 	if(status) {
-		logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_ifrn.ifrn_name, strerror(errno));
+		logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_name, strerror(errno));
 		return false;
 	}

@@ -157,13 +157,13 @@ int setup_listen_socket(const sockaddr_t *sa) {
 		struct ifreq ifr;

 		memset(&ifr, 0, sizeof(ifr));
-		strncpy(ifr.ifr_ifrn.ifrn_name, iface, IFNAMSIZ);
-		ifr.ifr_ifrn.ifrn_name[IFNAMSIZ - 1] = 0;
+		strncpy(ifr.ifr_name, iface, IFNAMSIZ);
+		ifr.ifr_name[IFNAMSIZ - 1] = 0;
 		free(iface);

 		if(setsockopt(nfd, SOL_SOCKET, SO_BINDTODEVICE, (void *)&ifr, sizeof(ifr))) {
 			closesocket(nfd);
-			logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_ifrn.ifrn_name, strerror(sockerrno));
+			logger(LOG_ERR, "Can't bind to interface %s: %s", ifr.ifr_name, strerror(sockerrno));
 			return -1;
 		}

diff --git asrcraw_socket_device.c bsrcraw_socket_device.c
index f4ed694..cf13fe9 100644
--- asrcraw_socket_device.c
+++ bsrcraw_socket_device.c
@@ -61,12 +61,12 @@ static bool setup_device(void) {
 #endif

 	memset(&ifr, 0, sizeof(ifr));
-	strncpy(ifr.ifr_ifrn.ifrn_name, iface, IFNAMSIZ);
-	ifr.ifr_ifrn.ifrn_name[IFNAMSIZ - 1] = 0;
+	strncpy(ifr.ifr_name, iface, IFNAMSIZ);
+	ifr.ifr_name[IFNAMSIZ - 1] = 0;

 	if(ioctl(device_fd, SIOCGIFINDEX, &ifr)) {
 		close(device_fd);
-		logger(LOG_ERR, "Can't find interface %s: %s", ifr.ifr_ifrn.ifrn_name, strerror(errno));
+		logger(LOG_ERR, "Can't find interface %s: %s", ifr.ifr_name, strerror(errno));
 		return false;
 	}

@@ -76,7 +76,7 @@ static bool setup_device(void) {
 	sa.sll_ifindex = ifr.ifr_ifindex;

 	if(bind(device_fd, (struct sockaddr *) &sa, (socklen_t) sizeof(sa))) {
-		logger(LOG_ERR, "Could not bind %s to %s: %s", device, ifr.ifr_ifrn.ifrn_name, strerror(errno));
+		logger(LOG_ERR, "Could not bind %s to %s: %s", device, ifr.ifr_name, strerror(errno));
 		return false;
 	}