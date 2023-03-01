class Cocogitto < Formula
  desc "Conventional Commits toolbox"
  homepage "https://github.com/cocogitto/cocogitto"
  url "https://ghproxy.com/https://github.com/cocogitto/cocogitto/archive/refs/tags/5.3.1.tar.gz"
  sha256 "ac6847ce55ba284184d0792afb53c6579da415600bc1b01c180dd87ad34597d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0afcff66d43ccd5fbc73acc749a6ccb4aa809bde574c5b76c2146d43dfbdf937"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca16d35db198afd58e3ba2fe1eb180ee21a702361873480970e28bfbeda7500"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb362b0af4bd62af39e49b2737d9b034874997088e937b128239be632385ea38"
    sha256 cellar: :any_skip_relocation, ventura:        "85d23bbeb2ee06d602e9e78fda757aa00c9a36431b67bf0fa1e59360c1414fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "f6645a3f30b55f1446952ece67ca49f2c1058b0ce3595fa0aa7ac6a7c054c445"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c8058d3fdeed4c3d9c652a9e136745b79c09d9a7f77dfbe031a196bce2373dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a9c51c4a4a154710e738290684698cf0dab3952321d9ec6d86e26bb565859f"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"cog", "generate-completions", base_name: "cog")
  end

  test do
    # Check that a typical Conventional Commit is considered correct.
    system "git", "init"
    (testpath/"some-file").write("")
    system "git", "add", "some-file"
    system "git", "config", "user.name", "'A U Thor'"
    system "git", "config", "user.email", "author@example.com"
    system "git", "commit", "-m", "chore: initial commit"
    assert_equal "No errored commits", shell_output("#{bin}/cog check 2>&1").strip
  end
end