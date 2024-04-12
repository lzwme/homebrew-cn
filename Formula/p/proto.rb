class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.34.3.tar.gz"
  sha256 "9388680b7dac548847c237bbe554ff2daa56b2b372f492c0f42673426b759f17"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43e0df1803bb8a831b888170955fad23a7a5646fed3f51046d4c2e069e8a32b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e6719b019dcbf4d33acef4dd455c4b008b8c0c348161dba51e0e947b90fdf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ef9f51b924a461850f2bc62e87a25ad4062d37aad8a9c744e6f1444e639e1f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ae3258197d77ca758f92bd4b9d73de7eef9b40356c1245f51c3a0481c45ad9c"
    sha256 cellar: :any_skip_relocation, ventura:        "68763005f38b0d3082948ca554044488c73087c8c67bb3c9210289444243ba84"
    sha256 cellar: :any_skip_relocation, monterey:       "6bd7d5ef0cb1c52e1a3e077e66b29c9ac6205ebf62011dd8e0a1bdd3d8d927d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb09f08bb258ffc11c7849c312942d40e17077df9600a06c808a8dee20216b14"
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