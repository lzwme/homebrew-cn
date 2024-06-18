class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.37.0.tar.gz"
  sha256 "a0d86b412b6a62b7e0c53d701ff4467275bfd5c7e2c2590d1a5637a728ca240b"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea60ce7351c2f9124dca9bea6a66196474666c8089eca00d9dd4a0d9c678f1ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb00d53c2ccd9fa8a862d25fa5c323ee1804fe32abb80bffba201c21687ac0d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "646da68b763e74c8c0633505f7e1e7eac01a4492745fe59c1a8bd1ffc379b8c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec25393cdb28f7b8f08b87876268433643cfbbe43798ffe5c66f816687bc9ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "6b9d1b60d655ea5589496c793793e25d2d6d10e2e050860d02394f84ba522395"
    sha256 cellar: :any_skip_relocation, monterey:       "d781cee979fc2b54a0e9195ab98c668bdcc3bcd39ccb4a49b941ef104ca71741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbddbef9dc4e2b32b9fe4153e0739d6641dab636b4a90c3f372d694e6ebc1fd6"
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