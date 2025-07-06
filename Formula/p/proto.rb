class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.50.3.tar.gz"
  sha256 "8a4e9c120b23d0786b1957d9c5dc5b6e8f1f0c6fcd43fb6a6d4f1a99967baf9e"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8df2f7aa771852f4acabdcc5f84b1036fcd72190a4705022927d41363509080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0231ae61330c35c3b99e74c5917fb5b208eea48b45f983c7e9c286c6518e78ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b25ebcc06f71a3322afffdcbfef195c7d192b28d589c999fb1e1322eccb0c82e"
    sha256 cellar: :any_skip_relocation, sonoma:        "716bf08dfe4b217e429dab7307c383b83677b1f53818ab960d97796a54291416"
    sha256 cellar: :any_skip_relocation, ventura:       "d80b14e0d71c6db006b47741ea0058b05cf75acaa688101f5c1a325f791d8a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c936f518fbd82f0f0ccd12af9b3d02436cc2f38f0402d46f87bc965b6bec5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed0cfeff7642cbd41a5a8296529f5756280910abe69e589f13450fbd1245ce14"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
    generate_completions_from_executable(bin/"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec/"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (bin/basename).write_env_script libexec/"bin"/basename, PROTO_LOOKUP_DIR: opt_prefix/"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin/"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.proto/shims/node #{path}").strip
    assert_equal "hello", output
  end
end