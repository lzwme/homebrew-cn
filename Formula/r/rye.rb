class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.comastral-shryearchiverefstags0.35.0.tar.gz"
  sha256 "380c23fd0a667393bbe15effa55f4ce51a29811761c42b793c24a5b695d0baec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dac626787fb9cc81dbbce8c218882f6d9ef56969ec9f8fd66bd21bb1d9631a82"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9de175a8d0cca4f14c8506a1a26fabf59b40fefb95435a40b549d40cdc5bb7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19f97e7c240e2c431902070c1c09866d6dc9798675283fc81af46578f4b37279"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a85f53ad80f18ca1031503a8b742e1f26b79e5ea18ddc9a4dd7281cec4ed2fb"
    sha256 cellar: :any_skip_relocation, ventura:        "8f3c665651a51eb25b66cfec4e647749aa810184eacdfd0d2389c544ad68ce04"
    sha256 cellar: :any_skip_relocation, monterey:       "f71eb6abf7d10b87cdc3233c39bb64d92711963fa2001eeb5f93eccdae33b8ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069d1b7ad544e2f181738797fb0b5dced620e6b229358bc101d74e2db7f35b43"
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