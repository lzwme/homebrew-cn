class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.29.3.tar.gz"
  sha256 "b2108b0929fe4b6b39af55bd6e8c55e0b3bb0eefe4f337600479213ab37eb54f"
  license "BSD-3-Clause"
  head "https:github.comhangxieparquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f0cb2aec743093d12b00024fef67d1773ab0bd546de90ef71427b68336ca1a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f0cb2aec743093d12b00024fef67d1773ab0bd546de90ef71427b68336ca1a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f0cb2aec743093d12b00024fef67d1773ab0bd546de90ef71427b68336ca1a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cda385ebf4cc127922d9ba0697a17fff63c77e844e5cc4fe9132687b3365346"
    sha256 cellar: :any_skip_relocation, ventura:       "2cda385ebf4cc127922d9ba0697a17fff63c77e844e5cc4fe9132687b3365346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595ff2bf1f51e2fc6296f67ab5e2538b8818bcd0b13685bf08ebaf241a8b08be"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https:github.comhangxieparquet-toolsraw950d21759ff3bd398d2432d10243e1bace3502c5testdatagood.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}parquet-tools schema #{testpath}good.parquet")
    assert_match "name=parquet_go_root", output
  end
end