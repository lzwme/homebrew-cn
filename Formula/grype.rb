class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.64.2.tar.gz"
  sha256 "1b8deef64dc59175b8ef84df6d52924ab363b7d7827ed84a5561ee10949dbfff"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e05556d3e5c0e1a015f7042162832a6b215fcb04a6a663d625a775cfe3feed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84002b3af13b65c7ae336e9e24ef1132196a09d8da5f494468c8903662fb346c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf8b339c1e99d449ccac081cfb6533722b5b8e137fa4fd6a96d4bced3c4c9311"
    sha256 cellar: :any_skip_relocation, ventura:        "fd9276d24ab32f9c2106c14886bfcdf3d7a310f781b85aad93b0acdb43dcb24e"
    sha256 cellar: :any_skip_relocation, monterey:       "6d7f10910684d29ba59432ae80cd433fde0fcd9c3f180b0a309b381c228576d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "89d914916a669e29f5a3f0926bd99e28a1cc3b6dc0736cf8096aacd8a80d5c7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a62fc7303d3702ba86e422e7b4b4cde05ebbf62af67f839b3b3d4f4c1c73b7c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/grype/internal/version.version=#{version}
      -X github.com/anchore/grype/internal/version.gitCommit=brew
      -X github.com/anchore/grype/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check")
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end