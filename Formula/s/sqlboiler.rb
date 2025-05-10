class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https:github.comvolatiletechsqlboiler"
  url "https:github.comvolatiletechsqlboilerarchiverefstagsv4.19.0.tar.gz"
  sha256 "39f106e8846f818a71f81e7863e38ff154f351e758c15e25312882fcfdad2ca8"
  license "BSD-3-Clause"
  head "https:github.comvolatiletechsqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91baa67ed1eb0f569395fd5731006bc1401516a13f5261fca90037df3cc01b48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91baa67ed1eb0f569395fd5731006bc1401516a13f5261fca90037df3cc01b48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91baa67ed1eb0f569395fd5731006bc1401516a13f5261fca90037df3cc01b48"
    sha256 cellar: :any_skip_relocation, sonoma:        "2074aa55cde9dbc8c0387148750788a968da5266009eb141fbfc428555285ecb"
    sha256 cellar: :any_skip_relocation, ventura:       "2074aa55cde9dbc8c0387148750788a968da5266009eb141fbfc428555285ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be93948ff6fabbc25d0545c21bf276d0b1189838be7ecf7d750839af9f71dfaf"
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