class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://ghfast.top/https://github.com/DataDog/pup/releases/download/v1.10.9/pup_1.10.9_source.tar.gz"
  sha256 "41320c6b785b466c9680da0a8bc82b6a391178a436cf48b3d5aa9ab24c5b612e"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c85fef305951b9c1eb6cfd196f1363d585416b648fc102918178c3a14de54f0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c73bb58b0a2b4a48abf179fc1202298e6d1d940b3296b56994b9924342b7472f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba774643c642fe701e13fe0bf604d45f7fc262605622119b0941a720e6edbcd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1250f3279f7fd811c3eacb1ebc07d75e2899c3ca598b41d16df597a14d9a563"
    sha256 cellar: :any,                 arm64_linux:   "de22958a791c9df597ca0453efea0bc30c06e777ba0aaa7521a1c69fb5e010fb"
    sha256 cellar: :any,                 x86_64_linux:  "c604132c4a766d4206b3290722922e9e3c30e6a708b77c1408a4c4bb136f5a32"
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