class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.30.0.tar.gz"
  sha256 "a564e4c8a4d2483b19e02bd1b3cdac5db4ad61cc0e2d217203f0a641897ba7f4"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a871c686e9b9dde5bff4afcdb111a9fa0b0bd0597054a9f2813969c679d3a7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b81b308d7c15ee5bdbd387d7b76c9183e68a7b2bb8fec182f71f9bf8dd88dc14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b6c7c5b934dcda40098152a4f0bbf3205018d62af9dc3695a669e01363aace7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0be3206500d4618f7cbf51db4529efd8a54ec19925b98ddea75cb666995bb482"
    sha256 cellar: :any_skip_relocation, ventura:        "42b662d30e8d7c2e456eecee6adb745bdb68c13a87b090bd8cae7992fb6a6738"
    sha256 cellar: :any_skip_relocation, monterey:       "b0276404090d208693f5bb7a761d84a50b2654c331e19fb7bbd3bc03f8445925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c19fa2c7de34e1cf0a349e8e66e8b613b6717e4a34912b4928779f2c31ce71e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, PROTO_INSTALL_DIR: opt_prefix"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.protobinnode #{path}").strip
    assert_equal "hello", output
  end
end