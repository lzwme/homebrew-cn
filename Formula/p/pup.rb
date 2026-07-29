class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "c352b0059882810dacd8f0bc89b2a79d9e410e11029a1ce41ed3af93f0c6e122"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d378ae26bc771bf29151f26060126c1367f3e05cdab6b3666c77a2d749e9a58e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "544a14741974dba3ee363885441f36c28a0d00f32fa9c0bf9a67486b9271e7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9e602f2bebb8d0896be8aea30748f0ade34e6eba10f30cf4d09c75d67f267fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b6c9ddc52d6859b1e7c346aeddee22124a906ce4b1e051c2d1faa5b119b0036"
    sha256 cellar: :any,                 arm64_linux:   "a58776d466417006a981f2a264eb0ce83ae72e42e61a13812c9a851465c86225"
    sha256 cellar: :any,                 x86_64_linux:  "23a0853a57e938f12a9ab0a514d03be421ac157dbe0dd51284542da97dcd64e3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end