class Rye < Formula
  desc "Experimental Package Management Solution for Python"
  homepage "https:rye-up.com"
  url "https:github.commitsuhikoryearchiverefstags0.20.0.tar.gz"
  sha256 "8453d0b0b731f0dd9eaf24b2961dfb3b5d56a7225f6fa3105682cc2c5cbdb1ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5d7171e0f620fdfcf015299822bef79a7f192967eb5b94b0ecb2f77193bc579"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0627c29c326f9108ee43e7222eb0929d1818d03b7cf63f50cf9e82c6797ea5a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04f6c516c030e0daad4097b1d401540798fc754becfd1a572acaee9eec074cd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "45511d6c0153f689a344534bedb3e5647aebeeaef87647950d021bca2a95cb25"
    sha256 cellar: :any_skip_relocation, ventura:        "60bcd44ada8040e831ccb47a714fa80624e22a2a19894e3e785ee22a9379a6a6"
    sha256 cellar: :any_skip_relocation, monterey:       "83146a7e18219d1043b175c6de9ad0d802bb320e88a2882f15376c4ebc0cd201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f3656685e110ae5e415d8c96f1873f540eccc35cf219bf1fd262182bb2bc5f"
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