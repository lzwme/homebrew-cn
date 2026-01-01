class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://ghfast.top/https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.19.6.tar.gz"
  sha256 "e016d069ec5c6a363019899857aa522dbb14e72c8034048d490be4e045dc7073"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c25806bc9e49e46a56884c91ce7b0407b17c84b10ef009ba58112773f0ee6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c25806bc9e49e46a56884c91ce7b0407b17c84b10ef009ba58112773f0ee6c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c25806bc9e49e46a56884c91ce7b0407b17c84b10ef009ba58112773f0ee6c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c876ec35f7993973996f7dae5cbdddb307555bb6428e8dfaf98cb6f1b3fc887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fde34c3561274c55601a868846947bc7526d017585617f22e590c6d9c1bda31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafe10042a4d9f3c7ac05bbb8e82bd0e975c7c330d0a35f7e0e04534b2f5fbfc"
  end

  depends_on "go" => :build

  # Fix incorrect version reporting.
  # Upstream PR ref: https://github.com/aarondl/sqlboiler/pull/1468
  patch do
    url "https://github.com/aarondl/sqlboiler/commit/59f05ce1e989295571789514f68bbd0bff18b730.patch?full_index=1"
    sha256 "a892cdea048c66d4ffbb701c5983c158b6eb74bcf23cc2239728b184aacfdd88"
  end

  def install
    %w[mssql mysql psql sqlite3].each do |driver|
      f = "sqlboiler-#{driver}"
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./drivers/#{f}"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/sqlboiler psql 2>&1", 1)
    assert_match "failed to find key user in config", output

    assert_match version.to_s, shell_output("#{bin}/sqlboiler --version")
  end
end