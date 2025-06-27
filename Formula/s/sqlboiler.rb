class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https:github.comvolatiletechsqlboiler"
  url "https:github.comvolatiletechsqlboilerarchiverefstagsv4.19.2.tar.gz"
  sha256 "27320df592ae8b143861baf4a93c0a5e142c1fdf61db62feeb98efcaeac8aa40"
  license "BSD-3-Clause"
  head "https:github.comvolatiletechsqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4add434e7c891fa931251afed3a07c682f5fd25e1f87b744f3a2e851e5c2af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b4add434e7c891fa931251afed3a07c682f5fd25e1f87b744f3a2e851e5c2af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4add434e7c891fa931251afed3a07c682f5fd25e1f87b744f3a2e851e5c2af"
    sha256 cellar: :any_skip_relocation, sonoma:        "76ca857d4f6e7247dded84268526b81f06e95b2d51c8146ea832d2f90bd3efb2"
    sha256 cellar: :any_skip_relocation, ventura:       "76ca857d4f6e7247dded84268526b81f06e95b2d51c8146ea832d2f90bd3efb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c776177db9bc32682c923be3f363fcbb99129799e9f518088322ce14458b078d"
  end

  depends_on "go" => :build

  # version patch, upstream pr ref, https:github.comaarondlsqlboilerpull1454
  patch do
    url "https:github.comaarondlsqlboilercommit6a39f792d9e8ee838697a63284a4bf999d02440d.patch?full_index=1"
    sha256 "c8f816926066ad16ed9cfd87f20be230b9751686b0519fe088d04011ede246b8"
  end

  def install
    %w[mssql mysql psql sqlite3].each do |driver|
      f = "sqlboiler-#{driver}"
      system "go", "build", *std_go_args(ldflags: "-s -w", output: binf), ".drivers#{f}"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}sqlboiler psql 2>&1", 1)
    assert_match "failed to find key user in config", output

    assert_match version.to_s, shell_output("#{bin}sqlboiler --version")
  end
end