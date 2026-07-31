class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/3.3.0.tar.gz"
  sha256 "f1f7082f48b2e2b22a3be04f867634471bbc30565c8cb0c5a908ac3f9c50fa7e"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5ee0c721c44b20552efd9c3a3e52071796de7d4715ee44ebba57dcaf7d89012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa16d02f452cb0787deec74965ca7294cb1fe5145dcfe1f1d193ceda74ebe89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92a860cd127d5ea10b34f93ace2353d4bd646324f0c5eec33a425d2be509a82b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dbbafc0b84bca55d911234e9cc38fbb7d58fce7582700b4dc1c90501f90d292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1410af0d809ee914ccd366f3390a26fcb1da9b4b1197375585f320c2bf1ca9f6"
    sha256 cellar: :any,                 x86_64_linux:  "2cc9c5ebd65a8127c92529932d43e1dfeab3257099f29ddedacbec0387803b28"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end