class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https:github.comlaktakchkbit"
  url "https:github.comlaktakchkbitarchiverefstagsv5.4.0.tar.gz"
  sha256 "13fb0627475e2ab1ba5486c4a0290228930b80e57cd99254efa9d001df31eacb"
  license "MIT"
  head "https:github.comlaktakchkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f82a3b2a523e105f931fc045d5af9de18115117fdb2b96aaaabc50523fc4fc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f82a3b2a523e105f931fc045d5af9de18115117fdb2b96aaaabc50523fc4fc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f82a3b2a523e105f931fc045d5af9de18115117fdb2b96aaaabc50523fc4fc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd781742c5fd2b4834c832225e35a13e0bd8d834d974da9c1e4f90c807f2cb6"
    sha256 cellar: :any_skip_relocation, ventura:       "6cd781742c5fd2b4834c832225e35a13e0bd8d834d974da9c1e4f90c807f2cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c157b96149cfc77d83a067d51ceed5b912e84e7bbf97521b0600eb56b03bde"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdchkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chkbit --version").chomp

    (testpath"one.txt").write <<~EOS
      testing
      testing
      testing
    EOS

    system bin"chkbit", "-u", testpath
    assert_predicate testpath".chkbit", :exist?
  end
end