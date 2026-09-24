class Bubblewrap < Formula
  desc "Unprivileged sandboxing tool for Linux"
  homepage "https://github.com/containers/bubblewrap"
  url "https://ghfast.top/https://github.com/containers/bubblewrap/releases/download/v0.13.0/bubblewrap-0.13.0.tar.xz"
  sha256 "4734237473c0e5d695e4e9034a34e43b2dbf5164655bd13fa59ae376b2b7a765"
  license "LGPL-2.0-or-later"
  head "https://github.com/containers/bubblewrap.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "457d114366fe1f5497cc8caeb79bd9f3b8706fd2062db8a903ec9f67310ccef3"
    sha256 cellar: :any, x86_64_linux: "7f4ab6945d2667f5eae6dde9aa4844a82a8bc3244a5c2a840c908332a753a9e0"
  end

  depends_on "docbook-xsl" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "strace" => :test
  depends_on "libcap"
  depends_on :linux

  deny_network_access!

  def install
    # Meson modifies RPATHs during install but cannot handle paths injected by
    # our shim and results in a non-relocatable binary. Instead, we can remove
    # the shim RPATHs and pass them via the available meson option.
    args = %W[
      -Dinstall_rpath=#{ENV.delete("HOMEBREW_RPATH_PATHS")}
      -Dselinux=disabled
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "bubblewrap", "#{bin}/bwrap --version"
    assert_match "clone", shell_output("strace -e inject=clone:error=EPERM " \
                                       "#{bin}/bwrap --bind / / /bin/echo hi 2>&1", 1)
  end
end