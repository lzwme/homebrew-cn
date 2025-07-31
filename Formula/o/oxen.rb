class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.36.2.tar.gz"
  sha256 "243fe6bc600914510c8adeea4ce0f9885aab9aedbd69ab05b73c8f98560424a8"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6f3ea631e19bcb209d0e1726b261664d551482bbf2dbc213624cfc1e979d53a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d915dbf54f002249fd605c0c003fca1c336367f2f014eda8ce1c5554ffd8622d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f59979e57e26c1118d0d9b3f100448cc62dd1598a00ac285b4cae07880d16a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "42ba88a5abe762ec212dd2b113708aaf15ec7b4f81b0b9c4ec475152894c4284"
    sha256 cellar: :any_skip_relocation, ventura:       "3012ea0435a5afec15316bd991461ab1bd3a850927f758bfbdd0a5845ba6f4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5409d8ee7c3e4592a686176e8b085fe5489713ac5d1d644ea050befcf2ff3ea4"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  # Remove `procinfo` crate dep, upstream pr ref, https://github.com/Oxen-AI/Oxen/pull/93
  patch do
    url "https://github.com/Oxen-AI/Oxen/commit/d8867a02a8194e986e1c0e6727dcfea46ba8eb5e.patch?full_index=1"
    sha256 "511ef9a4a09ad3627fb6a9adf898862e45939529542e07d6c63300f90e74c85d"
  end

  # Add missing dependencies, upstream pr ref, https://github.com/Oxen-AI/Oxen/pull/94
  patch do
    url "https://github.com/Oxen-AI/Oxen/commit/d1961e1b49f094ff0247d75a3e5022f4a1999b2c.patch?full_index=1"
    sha256 "2eae56fd15abae3018e211a670e8552fff233893e4fdc9ce357415cb922feb26"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end