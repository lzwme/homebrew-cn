class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.51.3.tar.gz"
  sha256 "d77b498e5bdc347678ad63c44cc1bf0c736e9636003ee93e17de4c8af450fc00"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49b7f27c2690c7bd447bcd8648c2507394679c56d77432fc2612672e66c5a9f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfbdb20574fc5cd30050c537582db3746eb358501ebfe3a5dc8feaf31ac98f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9160f56ce033f8be64dffd9178b759e0ff87a847abac802709dfa8699299d794"
    sha256 cellar: :any_skip_relocation, sonoma:        "16e2277b89e16bf584bc348bb23cc626fae8f5c566eeb97872852f8a1a125696"
    sha256 cellar: :any_skip_relocation, ventura:       "67f96ab9b266f2e8745a29777f47674df144f73fdb0b5de314584f89e0cf7140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6201fc1898c53a7014378b5bfa49e564db08dbe0271cc1dc08a05ee10f72196f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080038c6fbd5d3b64816903cc003959c5921220454235c7dedd3f9771c9bcb8f"
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