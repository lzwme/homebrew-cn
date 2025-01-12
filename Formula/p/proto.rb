class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.6.tar.gz"
  sha256 "071da45b006c92be6187c40025526c4d67ae8a4f1b2a113212221bec35a371c7"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e4b16afe586654e72cdfa96bae2e44aea28f86e58e3e4ae7368993966ddaa1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8a52913a1885e7cc844f0a96d7c8259c317ad4fd04b259d4bfbefb76d9b8024"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4833c71619f12870baf5f310b0413a1041ff5b93948994fb7c71b6ed5d4274d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6004c208ca5be6689117b124c148fb6997fb49738b722dd04af45eb1d53618c4"
    sha256 cellar: :any_skip_relocation, ventura:       "03cadca8da3acf5f0698ab91ac263823e10f926b26e2ddc1eb6d460672cc75d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025eab5f21bf744135b0cce1d160881428147537d21bb6625ab68ffb17658734"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (binbasename).write_env_script libexec"bin"basename, PROTO_LOOKUP_DIR: opt_prefix"bin"
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
    output = shell_output("#{testpath}.protoshimsnode #{path}").strip
    assert_equal "hello", output
  end
end