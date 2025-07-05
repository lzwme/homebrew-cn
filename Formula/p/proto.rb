class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https://moonrepo.dev/proto"
  url "https://ghfast.top/https://github.com/moonrepo/proto/archive/refs/tags/v0.50.2.tar.gz"
  sha256 "25e897c8086428feb67a272dcee1b7e7870b0746e3f82dc78adeb7ac6ac5e8c4"
  license "MIT"
  head "https://github.com/moonrepo/proto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98cc8237a998d5a68ccd3be55939badfc00f0642383a3427266b44d5c19dee7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "018d942d55e72147fd0639c015a2a3f35264f41860895451cbfbd3789236064d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db42bf0b1e084862a42c262b12c2001d3062eefa41db7f0621f4ce0c2c4165dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "38bb324ee4ef4f89333bef0c32840e2ed18c5aa49b458ac3f0d482914b134089"
    sha256 cellar: :any_skip_relocation, ventura:       "7121c989971572644e680ce609d296c67de02bf1d59315633ed982676a2e8061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b9a70621a86561907845ffce8062cb9614f48d964acee99defbba71799fb775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9df2a0d2eb7c80c9048e31ff7cdfc1c5ae67b803db105e23df4a7390daeb5da"
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