class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.comastral-shryearchiverefstags0.36.0.tar.gz"
  sha256 "9f369a89e6ee770ab542b00acb2a188dfac105924a9387636ce472d4e8a72c9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ceea16e82431f2a3a09fcb8c37a92cf6be936d6f3cd58574fe0d3d0142b22260"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93bd3958efae3c425ef8a7e4c04d804a2182f9ea5b00530767a39879bfa193f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d112fb9384cdc92b4ccf71709f29d8b2290f26fc74bc66948bff159b3dbcd85"
    sha256 cellar: :any_skip_relocation, sonoma:         "a34810b23dd5ffcf99ff69e82861efbdf692bb90d749361959ba9e313f19c85d"
    sha256 cellar: :any_skip_relocation, ventura:        "bf7bfd02c5a5b3a1053f78c6a5ace01421ed4daca1441034e513ddb793b3a6f1"
    sha256 cellar: :any_skip_relocation, monterey:       "eea0aed1211262ca7563b3221430372c077bb8554072950cebe2d2f0c84deeb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a488a4dd95b4e29a08d6aecec9d2f3b1bd39b95fc1c79c6d138604cfc8a95a7"
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