class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "dbdd1b0a3b910e088a9f7fae5abef1f15aa3a7b7c4bef5c8cd3ceb22e6296c5e"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be558c9051549dbed664489c4e52547750976a95eacae2e09693003c104abec8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ecf451818960e23009570fdad370837d74206be3365341a72fa016c0bb2c1f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be3d13bdbea5e87e14f6af872d23fe529f7b7045b31259439e68a5f9aa840f28"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd4d350eabf3fc7ef2e3a0163f450f5b84997103a9331240515cbe33d38166d1"
    sha256 cellar: :any,                 arm64_linux:   "ce2e77dbae56e43c6a3b2225daa8a813036fe7c09deff544d351a10d39c57178"
    sha256 cellar: :any,                 x86_64_linux:  "d6d2b2009a3270a570bc48637f50b62cc1ecf7aeea4309b92bbfb0e91a13256f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
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
    node_version = "24.15.0"
    system bin/"proto", "install", "node", node_version
    node = shell_output("#{bin}/proto bin node").chomp
    assert_match node_version, shell_output("#{node} --version")

    (testpath/"test.js").write <<~JS
      console.log('hello');
    JS
    assert_equal "hello", shell_output("#{node} #{testpath}/test.js").chomp
  end
end