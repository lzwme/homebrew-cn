class Bkmr < Formula
  desc "Unified CLI Tool for Bookmark, Snippet, and Knowledge Management"
  homepage "https:github.comsysidbkmr"
  url "https:github.comsysidbkmrarchiverefstagsv4.24.0.tar.gz"
  sha256 "f5819eca0f28c2e26f56cc31e54f5041ada9a9da34e8299aaaf8b033a752b725"
  license "BSD-3-Clause"
  head "https:github.comsysidbkmr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b23deb3faf99a17e8a7fb332320aec7f4c5c04ba79ca904756ebfd6f2f2114a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4860f7cbbd0c7117def65a35de00301c5dcc8795a92a42e0ac426a73a493bab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cbf27854a7d42e92669144c642612ac338ed58ac8f432296ddd2330bece2117"
    sha256 cellar: :any_skip_relocation, sonoma:        "647fae8678ea598b5c931d4a582d12e9612cdf6d0501121b3b6e7028db21eedc"
    sha256 cellar: :any_skip_relocation, ventura:       "3d46cb792f62c1276ebab3d1c28e57d73c31ddc3b4c41f941e44f2a99c2a15dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bc99e5e4d2b5e10c18cc79596fd299f335946361d3feb00387402f5fed39ba3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b9d81a5340c9ed1a001aac24715c6d7a6addbfe20dc5c3eb5ba8890dee80f58"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "python"

  def install
    cd "bkmr" do
      # Ensure that the `openssl` crate picks up the intended library.
      # https:docs.rsopenssllatestopenssl#manual
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

      system "cargo", "install", *std_cargo_args
    end

    generate_completions_from_executable(bin"bkmr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bkmr --version")

    output = shell_output("#{bin}bkmr info")
    assert_match "Database URL: #{testpath}.configbkmrbkmr.db", output
    assert_match "Database Statistics", output
  end
end