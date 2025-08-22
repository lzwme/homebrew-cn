class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "a22af190801afa8084e66293e52c6bab0818242038e6ab4074804f0162a8fdfd"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bab0b5785ed8c0f4fa3dd933443a62467ed6dfc54397d0aeb1e283387e90fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3941ddbc305bfd464295ba2b7455017316ca98c5d56eab2e438708fb6d7eb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f17fb1427aeec4fd0ea1da1b37a998c0722d23bee2f4768c80240b1c350ac295"
    sha256 cellar: :any_skip_relocation, sonoma:        "69d0fa49abbf8d087ee3a93415a6630c77359a822d067fa3fd187a811844bd77"
    sha256 cellar: :any_skip_relocation, ventura:       "9b048f612d45cb9923b896d7d512672347bb3e564f43829c5eeed49589a3b39f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69f5d36acf270fc29e921085ecf2f7df245df17571a91d4400ba123fa4ad3fc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c9ce43a6ad12b1e97656dc8c91eec7aede43e35e7e9f01a88513984ebecbd01"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
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