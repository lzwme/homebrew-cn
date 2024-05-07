class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.35.0.tar.gz"
  sha256 "9aa9c0f23c77356f8357dc131f974355e227b94d66046596f946d7ce2674978f"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "116b42ed2f31fe5e782ac54c108cfe7de96417bef01c96279234430b440ca06d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28b16adc3494da9551115cc5001ccb1a49bd9d6ffd39ba9faf51439022973a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05e7af02c8d3422e9527d7476c5488a1e30d632993bd4152b5c3e30400a9c65e"
    sha256 cellar: :any_skip_relocation, sonoma:         "96df1c0b992eae588a9a93e755be0a3bae18912bb9eff750be5c8d72c88ac6b3"
    sha256 cellar: :any_skip_relocation, ventura:        "daf028adea6f0134359edfe0148ce63e5714c171343297ac9818a7507bfb738c"
    sha256 cellar: :any_skip_relocation, monterey:       "88e8a53e52d977866f1159b2140811f604af7a9c281027105a9979ea43421fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608e7d90f0717f11ce302856b21965da739c430bfbbfd780cf08c0670f51dc01"
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