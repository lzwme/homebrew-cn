class Vaulted < Formula
  desc "Allows the secure storage and execution of environments"
  homepage "https:github.commiquellavaulted"
  url "https:github.commiquellavaultedarchiverefstagsv3.0.0.tar.gz"
  sha256 "ea5183f285930ffa4014d54d4ed80ac8f7aa9afd1114e5fce6e65f2e9ed1af0c"
  license "MIT"
  head "https:github.commiquellavaulted.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fde70166c645a842baec036f638bc3e0435f22bcc2c16fd2e81186ff200c882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43bb79ce25f0da8778ab20ed2bbb322674d256edb638cb00b502eb1dec31dee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af4905ab6698699c3f794645c49052db9bac1a63f025f35ec81f21c057a38faf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cdbcf9ca2bf59f73b8dad9d409410bc49c5e682def3025b543d57ec29ab88ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "8462a0d5dfcc77e7f6ea5975ea9c10a83444a66139b20d667473db42e7959362"
    sha256 cellar: :any_skip_relocation, ventura:        "1d176247a329b9986e3d85dc57cc01f1296268c647b7c60b70219adb25847735"
    sha256 cellar: :any_skip_relocation, monterey:       "bd52afb1a8d91c97a398e247f115fd65fdb77635a8148059bacafc2473ec6fbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d28ce78d9de727b84a069328160ec719db14789645e6088d67eeab462085722"
    sha256 cellar: :any_skip_relocation, catalina:       "6e28a27d6d1c24b2cd7d3ca0ff147a8309425dcd1d405861378bd40c191af5d2"
    sha256 cellar: :any_skip_relocation, mojave:         "246a6e46d12ceb79f4406802a72860a4d4e381bf34b8228c10773898b33dbb3e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "24f80eafb9d738391a99724915f07a546ebc822d5e3ab725fc90bfa690cc4ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3acf911a97ce6aa9aacff3d0e39c70d497e2b2b808a5ebe620301259035988c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin"vaulted", "."
    man1.install Dir["docmanvaulted*.1"]
  end

  test do
    (testpath".localsharevaulted").mkpath
    touch(".localsharevaultedtest_vault")
    output = IO.popen([bin"vaulted", "ls"], &:read)
    output == "test_vault\n"
  end
end