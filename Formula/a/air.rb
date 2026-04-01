class Air < Formula
  desc "Fast and opinionated formatter for R code"
  homepage "https://github.com/posit-dev/air"
  url "https://ghfast.top/https://github.com/posit-dev/air/archive/refs/tags/0.9.0.tar.gz"
  sha256 "55cae527153badeb348b7b04ffb3c9f1d9f20e27e388edeae694a05a5e32f289"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3afa199604236000fa16eb70fc23e5317ed988644267e8b5419cd73d774c98a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c48c38647dbffd201d4cbece8a8ef25eeb0346a4d875bc04a520e5d0c20ddc1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c302073e4965ad16eb6d05c175630a2809b0998bb155ccaa8924cd0e7efac2ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc59d65410f8408c2393f140a4964b83673bb5aece71aa29151a4b5abbf191f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f196234379fe472c694a8b5ce1a2a4407d90a1f79da94967bf8496ab645db509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4584b4a30f4d7dfe45e97b1ae746b7fc1bd050bc8427b43866dd2acb1954a334"
  end

  depends_on "rust" => :build

  conflicts_with "go-air", because: "both install binaries with the same name"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/air")
  end

  test do
    (testpath/"test.R").write <<~R
      # Simple R code for testing
      x<-1+2
      y <- 3 + 4
      print(x+y)
    R

    assert_match "air #{version}", shell_output("#{bin}/air --version")

    system bin/"air", "format", testpath/"test.R"

    formatted_content = (testpath/"test.R").read
    assert_match "x <- 1 + 2", formatted_content
    assert_match "y <- 3 + 4", formatted_content
  end
end