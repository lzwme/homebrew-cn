class Pocketbase < Formula
  desc "Open source backend for your next project in 1 file"
  homepage "https://pocketbase.io/"
  url "https://ghproxy.com/https://github.com/pocketbase/pocketbase/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "ae0bbf9a6227f6a6eacc877f098b9c56cecc3398ea8f0eea09e1bb68206aea84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaaa88888702563713ee38d8c05952a6c32412e56e7fa5e51e8cbbab5f0559cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaaa88888702563713ee38d8c05952a6c32412e56e7fa5e51e8cbbab5f0559cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aaaa88888702563713ee38d8c05952a6c32412e56e7fa5e51e8cbbab5f0559cf"
    sha256 cellar: :any_skip_relocation, ventura:        "476ff544098dff63f2aa2403d264741451225e600690a9cb8cc9bbc3376ef150"
    sha256 cellar: :any_skip_relocation, monterey:       "476ff544098dff63f2aa2403d264741451225e600690a9cb8cc9bbc3376ef150"
    sha256 cellar: :any_skip_relocation, big_sur:        "476ff544098dff63f2aa2403d264741451225e600690a9cb8cc9bbc3376ef150"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4439210b0bd5e3fbe120fd71f42832d67356ddcd630fbba8f6510e107523dd2c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/pocketbase/pocketbase.Version=#{version}"), "./examples/base"
  end

  test do
    assert_match "pocketbase version #{version}", shell_output("#{bin}/pocketbase --version")

    system "#{bin}/pocketbase", "--dir", testpath/"pb_data"

    assert_predicate testpath/"pb_data", :exist?, "pb_data directory should exist"
    assert_predicate testpath/"pb_data", :directory?, "pb_data should be a directory"

    assert_predicate testpath/"pb_data/data.db", :exist?, "pb_data/data.db should exist"
    assert_predicate testpath/"pb_data/data.db", :file?, "pb_data/data.db should be a file"

    assert_predicate testpath/"pb_data/logs.db", :exist?, "pb_data/logs.db should exist"
    assert_predicate testpath/"pb_data/logs.db", :file?, "pb_data/logs.db should be a file"
  end
end