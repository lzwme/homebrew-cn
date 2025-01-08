class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.4.tar.gz"
  sha256 "47040600a37db720d22f0e8ff787359173b93d10aa387e6b01c211298fd036d0"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "596ec94808287d000d2014ceaf0d4e7372e56414788bcb282ea777aa6209042f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c02f3d186aa77070d4b89fcff8ae1edb7ce6da2b148669c56eda1704f262a50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c511434a8b838d769375e41b12d3ad71299ccc6725e8578709f38a35f3758f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b61d9c0aed5b95fbc6a7b754d0fb254ad799b537a65541669910682242383499"
    sha256 cellar: :any_skip_relocation, ventura:       "6dc1772cbf9743beebbd38b121b82e0d2955d10fc4c35c4bc0803caa1d739477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d8e37127828c57c3e6eac718a79559e50dda217c06f239579105536b8ec6f29"
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