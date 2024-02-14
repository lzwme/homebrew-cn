class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.23.0.tar.gz"
  sha256 "b45fbd792f404631ddec6e2997d1c7c7162d1c9f569a7f28241c5652267b9514"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ea502fa12ec327f72ff76cbe16983bf86b97321ef0cb3af2f4228adcd9cdaae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e74b9d1f041c014e55cede502e9a1a0b66e44679a87a37a5ebb189b398ce55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eafaa9d65543bf44075913e3fbcf87d8c72ae8d665a5193480c04b28a3f1718"
    sha256 cellar: :any_skip_relocation, sonoma:         "9448e6de56ee9fc8cc3200e51affc8c9c3e89614f1ce297a254cbc67e387676d"
    sha256 cellar: :any_skip_relocation, ventura:        "cb58b4c9bc4e3961ac5e445a023efd021614cde6e746fb248b0a83fde0cf6009"
    sha256 cellar: :any_skip_relocation, monterey:       "947879efd9c4d7da54701eae0b0209e29f6db037d83157e7e8114ae23ec8e150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c09266adfe1f3cf946190701a290ad2d4c404e6fb82e861606e204d3c755e76"
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