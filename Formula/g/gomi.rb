class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.2.2.tar.gz"
  sha256 "3943e508633a388f263bdf96203a48fe5d30c88b2378853456a0e3eae9d10dfe"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fe650231c6cdb0a468e2d8f7283270f12d8e429278157d66f32128222226c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fe650231c6cdb0a468e2d8f7283270f12d8e429278157d66f32128222226c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fe650231c6cdb0a468e2d8f7283270f12d8e429278157d66f32128222226c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "a618ab04c5f5578912dadf86b10e84fe9feafd3e700a2a53660347008717f312"
    sha256 cellar: :any_skip_relocation, ventura:       "a618ab04c5f5578912dadf86b10e84fe9feafd3e700a2a53660347008717f312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372badc575a4efd9c31cc21ef47c454ea53c3f69b0929ae0a2758dd0731ebdee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gomi --version")

    (testpath"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath"trash"
    system bin"gomi", "trash"
    refute_path_exists testpath"trash"
  end
end