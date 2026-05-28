class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "1a4e5bedb6f422a4dfcdf53f84843d2372aa672663e9413ffc18b5754b38a0de"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dd59ad90681679a43079967aa682af29e2592b7a38a4be4cc40d468f17babca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd59ad90681679a43079967aa682af29e2592b7a38a4be4cc40d468f17babca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd59ad90681679a43079967aa682af29e2592b7a38a4be4cc40d468f17babca"
    sha256 cellar: :any_skip_relocation, sonoma:        "5180dbf41bf1903459ea3b4135b6c00be757427dab87038be27278072e76cdd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29bb280a8ef2ec77bce13faec73a30c9828d89994a24aade88e8739f9b7db32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7574854a8d712c42e85df1af6ad79d3add23726eccc393cd19a83ca4c9435574"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    ENV["HOME"] = testpath
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    review = (testpath/".crit/review.json").read
    assert_match "looks good", review
    assert_match "hello.md", review
  end
end