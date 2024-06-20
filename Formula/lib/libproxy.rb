class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https:libproxy.github.iolibproxy"
  url "https:github.comlibproxylibproxyarchiverefstags0.5.7.tar.gz"
  sha256 "ca64b28a014cffde43f4052ec78b25a8a0f1aa4d78da721c605d64b1591e78dd"
  license "LGPL-2.1-or-later"
  head "https:github.comlibproxylibproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b8330070a5e67629f94ce78ed2ea9a84fcbc5fb3516519b770593faf8c018ab7"
    sha256 cellar: :any, arm64_ventura:  "24435db5959aa7030a256f5a67922dee9c2ef43941b11e840a4775ed53af0a29"
    sha256 cellar: :any, arm64_monterey: "9afc1a1ebb74d35e51acfdf58ea81ce74feb67b681e0d233a366c4b0b7fa1944"
    sha256 cellar: :any, sonoma:         "c8804ddb7bb74cc4aff3f01502037828cd6feb13a796b822b64980006d2f3c26"
    sha256 cellar: :any, ventura:        "61609789916820fff179eeaf4b6e0e2b4fc9093a4ccdb2adf1b1650e051836ed"
    sha256 cellar: :any, monterey:       "d059725a935d953883006a83053743355abd3dd9ffa9bd179fc4615f98b26d0b"
    sha256               x86_64_linux:   "ddd70a1cd59f21f5b91aaf022f13e4fb744a19b82d7b752ebb2aef03e408f809"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gsettings-desktop-schemas" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build # for vapigen

  depends_on "duktape"
  depends_on "glib"

  uses_from_macos "curl"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "meson", "setup", "-Ddocs=false", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "direct:", pipe_output("#{bin}proxy 127.0.0.1").chomp
  end
end