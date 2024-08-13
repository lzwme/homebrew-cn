class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https:volta.sh"
  url "https:github.comvolta-clivoltaarchiverefstagsv2.0.0.tar.gz"
  sha256 "7cb34e39bca682eee35fa0ee908afdbfc833ce77b59c8b2ed9f6d7751d22df31"
  license "BSD-2-Clause"
  head "https:github.comvolta-clivolta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "770e914d04643cd9df8a578c93be0b1d0581279bf609b42b249aa5700e8f8ebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd642007cbd682a560f78153f013f94a8ace9f22495ab981a17fdeb36492cd4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4976f15cff289b8fa37f5b92c264dc9d170dc961ed3219f00e61edc06e4d5a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b8b5f904edca1e8293be0faea549eb962b2fcc4a3da14c1de151a31faff6422"
    sha256 cellar: :any_skip_relocation, ventura:        "26e50ad0f3bad42aaa02cde573c90ff285bcf5af03b2eb012f24632bd46d3c6e"
    sha256 cellar: :any_skip_relocation, monterey:       "cec8524c49a5a624d2cabef743b8ed1dd2e77447bfd3005fb14056abefc5a8af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6167c2a7b8904cd5f7ec6d3955a0d0f8382566ae06788c39146ea5f5b9ba3705"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"volta", "completions")

    bin.each_child do |f|
      basename = f.basename
      next if basename.to_s == "volta-shim"

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, VOLTA_INSTALL_DIR: opt_prefix"bin"
    end
  end

  test do
    system bin"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.voltabinnode #{path}").strip
    assert_equal "hello", output
  end
end