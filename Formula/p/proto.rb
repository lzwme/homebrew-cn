class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.50.0.tar.gz"
  sha256 "6cc874c96164e0d39a2eea19885b11398b370b79bb7e376cf61613296dd9dd65"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08d0c7a6630c3b9f7431ac7cc025b6d7c33f9da635a96504ac4f15a1fe903886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa80492d03c860d704dbcb6bf690a6030555e78d5e2fe3598452fd7af2ed74a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3be9fed77b0798f5539ea59f5dddb63be4f4d401cd3468ff83e97c512bff32f"
    sha256 cellar: :any_skip_relocation, sonoma:        "40d648c1f77a2c6c307d06e7788e2034ce3d69e7329909268f0c8650b6c05b08"
    sha256 cellar: :any_skip_relocation, ventura:       "475182f48d8d3ea37d3a79af6feea4cec97d266281358f94b8ce668341ff0a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24e3f64f210908a00a5775d6de0f6e87a0d8901f542ad8e964a0cd04e29c4fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efe2260719d08cc1ad2ae0da9e9dec3d65172ba79267931135d9f72bd64fb912"
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