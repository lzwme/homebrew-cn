class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.49.0.tar.gz"
  sha256 "aaf86ffbcca054935408341d236babca69d5f43a5cf78cfd2753b75a9c48ee70"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32e4cb98eaa2259be17cc0284ad45b9005cd92809f740b93f869b5527fba79bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "419da589366a4d4ac938d757c2977f732b31b29119ca8e5bb141b53b9053eedc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0150fb0f8c98beb334d433bbbe17c5f9f0cd0735c65b4696d65bc4179080c133"
    sha256 cellar: :any_skip_relocation, sonoma:        "c45eb21d0f3b183dd7351fb34e7cd33a43996ca36066c89ea35f0cd2d204f218"
    sha256 cellar: :any_skip_relocation, ventura:       "fb98658d1a5e08e76f09f84006a6ca75c1886385849bee169498e357d84465f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd485bd4bdc21112adcf97228428228ae7f49d817ce92f5316455e2bab70c9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6725f9b2e3b1984f7f3a325012476bbb1b457da922573b8c8088129f76f6239"
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