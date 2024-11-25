class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https:github.comByrongitoxide"
  url "https:github.comByrongitoxidearchiverefstagsv0.39.0.tar.gz"
  sha256 "50d8dcaa16e9a2dbcd89d6a68cae0c136734ca4b64a861a48ff6784e9939d4ca"
  license "Apache-2.0"
  head "https:github.comByrongitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7bfd67b2f11561b27e77046dafd1c10e080dda4ea84b049f70f6731abedbb31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6562e87efff85bf4be8f12cfbf04bc942a616a009f6ea3dd595979891113052"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7868a614c10ab26d8261cb74c60893eb0b69ba054b5fa0e533818ceef8b8006e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b11b8330687c31114acd57e671b1c8690a56950db597f4ea894d8eb04c3e9c1"
    sha256 cellar: :any_skip_relocation, ventura:       "f070474a0efd27c5223fed95edcff847bbf47d05c79561b29be11514abb1f448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cdf8d5783d0d4351f4615fe5dc8687371cd4df9e76d05b6a998bc652d7bd8fe"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid requiring CMake or building a vendored zlib-ng.
    # Feature array corresponds to the default config (max) sans vendored zlib-ng.
    # See: https:github.comByrongitoxideblobb8db2072bb6a5625f37debe9e58d08461ece67ddCargo.toml#L88-L89
    features = %w[max-control gix-featureszlib-stock gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin"gix", "completions", "-s", base_name: "gix")
    generate_completions_from_executable(bin"ein", "completions", "-s", base_name: "ein")
  end

  test do
    assert_match "gix", shell_output("#{bin}gix --version")
    system "git", "init", "test", "--quiet"
    touch "testfile.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}ein --version")
    assert_match ".test", shell_output("#{bin}ein tool find")
  end
end