class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://ghfast.top/https://github.com/tarantool/tt/releases/download/v2.11.2/tt-2.11.2-complete.tar.gz"
  sha256 "69796b57a755a5b22e05e6d7d458720ef06f83f2013e3f57d0f767930b342363"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c7d423d49418fe084529e504c43642f2314293e65cdc41d598cbd8513fcca02"
    sha256 cellar: :any,                 arm64_sequoia: "a4b0a87b32b4c26ce868ffaf4f18cc64f2152ddbb4746fbfa27f82f97c89bcf5"
    sha256 cellar: :any,                 arm64_sonoma:  "eacfab149f7f3d5b5119215530fd9b593e31d9245d9ea01b5daa4afc7f992ae9"
    sha256 cellar: :any,                 sonoma:        "560e90711ed7c71936f5894f413a862cd1ad10a6c5fc9006b594f323e9d0adf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48568301b12048b1f1367a2430bc7290d440d50872daa929b5923ae9baaebd31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74798c79c6916186f0db13eb666f17bf166fd611e85ec7cd544354bc6bd82aa7"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "package/tt.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin/"tt", "completion")
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end