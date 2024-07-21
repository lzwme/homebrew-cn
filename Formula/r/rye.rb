class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.comastral-shryearchiverefstags0.37.0.tar.gz"
  sha256 "a480c0d8b9d4bf67b54564521c16efd2ad4595f3ca365372421bfe20703af0f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bd150596650d6911b53175fcb2889eddb384961da099fad1ecd3cfbeb260965"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9805e521982b2ea836e39ed36835a817e6069f7e9be46d0f3d3fc1cc079fc5fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6016bd87e21f01a5c63f7ee0756dcec86949c2303572b24ba3c0f96fe3ea9b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "78336b6f615a608df60d0273092655b15a1b8ef2e6080ac4719f24d07d38ae50"
    sha256 cellar: :any_skip_relocation, ventura:        "ae3a87fb39286a595e839aaa121431817dd0b7bb5cbf3f4b19ced107f517363d"
    sha256 cellar: :any_skip_relocation, monterey:       "c738fa287cfcf34b5205cd679ec1f7fe32ee899489419d9d26702b25f66778df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa629b60cd059810caff044b60dd9bdcd8a8ad231405e2348dd27e3847be48c0"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "rye")
    generate_completions_from_executable(bin"rye", "self", "completion", "-s")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

    EOS
    system bin"rye", "add", "requests==2.24.0"
    system bin"rye", "sync"
    assert_match "requests==2.24.0", (testpath"pyproject.toml").read
    output = shell_output("#{bin}rye run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end