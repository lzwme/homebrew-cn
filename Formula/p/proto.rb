class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.45.2.tar.gz"
  sha256 "2cc013e3b033e6532bfc54e7b1a5c818ebc0ae24320f344722f33714caf23f38"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7eb474c99617e54fae2f0683c2d3763a1695b06c49b924764bc2de621f8e99e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9500b0930a53b8d805074e589acbfce9f9360381924be5360e1bdba9df99db81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba68849f10d19a6ded4563618de0e2d3e14f8a2fbfbcbdc924779e13ce24bef9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c3b00f7b5745fa7e246d0bfe3c877d3231ebedefc30008414d07b565966e172"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ae5db080dc80189f19c66df329506fedf2399cc386d01ffcf7507b296a318c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0eda220a1a241b895df820d401a5e57c1216bf9bfb321dfa292557f0da8008"
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