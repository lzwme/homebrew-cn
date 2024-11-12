class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https:github.comvolatiletechsqlboiler"
  url "https:github.comvolatiletechsqlboilerarchiverefstagsv4.17.1.tar.gz"
  sha256 "a9448abf87a3adb064e7efe1ed766ae6cfc10c337a669f4bf6489f6b86ffc737"
  license "BSD-3-Clause"
  head "https:github.comvolatiletechsqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd36428c9657c46a5cd5bc4152673e6d0c2b766864ffc3d281d29209a06b5b3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd36428c9657c46a5cd5bc4152673e6d0c2b766864ffc3d281d29209a06b5b3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd36428c9657c46a5cd5bc4152673e6d0c2b766864ffc3d281d29209a06b5b3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39cbbbcdd405c71a8026b86cb935aa83cde93cdaa846e0bbe584c9e51f68da7"
    sha256 cellar: :any_skip_relocation, ventura:       "a39cbbbcdd405c71a8026b86cb935aa83cde93cdaa846e0bbe584c9e51f68da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f14f33b1e37273b1b38d26874c7b465d814ece4a364f291e457017607f7d3e29"
  end

  depends_on "go" => :build

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