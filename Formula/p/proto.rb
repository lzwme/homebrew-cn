class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.38.0.tar.gz"
  sha256 "843b0fa45a1bb48a35d0ba6fd83b667605cde6afa0add9233256c92fafa3e96c"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc2e56188c4141db1f6ff448b36e335fa5a8f8031ee3a84200098801cd872bfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2bb7fccdc272b9e6ad4382efd40cc0c95f0b4375b5cd1eb7a13e784c107512fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedfeaa043c904fe061d248f80f001f2099e192b59085a03644fb70eaa05ae9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "31ce9e61931b97b50bf3e0378c7ebf054f7c42810103d27778c709b83ce4de69"
    sha256 cellar: :any_skip_relocation, ventura:        "9d5c644d54cfff4ccef74a32bcec377def233235ca95b5273a471345c2a61255"
    sha256 cellar: :any_skip_relocation, monterey:       "e8ec8f6c288eeb481b7cc831e070831e5e1b758608a1d601523566e723225447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61a96a05b5074255b7f1c54e0f74042fbd18accf3a9ae7dcd7b8d3f2b65677d5"
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