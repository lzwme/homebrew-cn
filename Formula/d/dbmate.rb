class Dbmate < Formula
  desc "Lightweight, framework-agnostic database migration tool"
  homepage "https:github.comamacneildbmate"
  url "https:github.comamacneildbmatearchiverefstagsv2.16.0.tar.gz"
  sha256 "d4edcfb32665887a628c91a2d3410a5c7bf305315ee873b888700762dfe5ec50"
  license "MIT"
  head "https:github.comamacneildbmate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "791cd3c2b8ab1b56dc377b8d0042dcf1634351fcca53a0cd49054f563a8f7fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e008679d3fbf9cf7faefa7590484f21bb1c9d43b9a4b6726f315013c7ed24d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f97b8e49651d30a515906114cb7e9caedb0a05b0100e09e98fa32a87e56abb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d8b2f512d3e8d3e5c139dbd1bc432b08bce9d73e014017d535a36a19110e0bd7"
    sha256 cellar: :any_skip_relocation, ventura:        "3b78d2e46dc020ef72af72dfb5d12d54f196e66cf71a62c181ee46b54ae87318"
    sha256 cellar: :any_skip_relocation, monterey:       "adabdcc8c439bc66c320602da5cb96ed2a9dfea7714b56a99dffe083eb96a9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "910a4bfb93554caea5dc0ad0fdfe4017b7dc04519cfd67c2dc29a1e7e8ac277f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "sqlite_omit_load_extension,sqlite_json"
  end

  test do
    (testpath".env").write("DATABASE_URL=sqlite3:test.sqlite3")
    system bin"dbmate", "create"
    assert_predicate testpath"test.sqlite3", :exist?, "failed to create test.sqlite3"
  end
end