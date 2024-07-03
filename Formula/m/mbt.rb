class Mbt < Formula
  desc "Multi-Target Application (MTA) build tool for Cloud Applications"
  homepage "https:sap.github.iocloud-mta-build-tool"
  url "https:github.comSAPcloud-mta-build-toolarchiverefstagsv1.2.29.tar.gz"
  sha256 "321f08c17925a158c84e20ba12393980db9582faa66cba62ccc8c7f3a563171b"
  license "Apache-2.0"
  head "https:github.comSAPcloud-mta-build-tool.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fb0465008eb644900f2710803f67bba50bf0d4af432069a80937ec6908bbc83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ebb8364ffa67ec3ea6e089ffa932d4367c33fbad75a291861977c8cfcceb4f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc2f3965cc835763485692c3c294af8b9e6cd138c27404f3e9dce66fa5c16223"
    sha256 cellar: :any_skip_relocation, sonoma:         "c34393d384683c051d4a5dc0713febccd93a7c954ace6d193c5afbef0f98b264"
    sha256 cellar: :any_skip_relocation, ventura:        "e350161441aeb0651405a6e31803432a828b4a9c0c23ce6ef37dbd2d8699b52b"
    sha256 cellar: :any_skip_relocation, monterey:       "97a96dc4c82983f8a3705bb01adfd41c524486c677f0ced705f0be41968d2f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f7232ffbb417e126f2d4392386eb170b77d9c978631353c9ba67d4c095a92c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[ -s -w -X main.Version=#{version}
                  -X main.BuildDate=#{time.iso8601} ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match(generating the "Makefile_\d+.mta" file, shell_output("#{bin}mbt build", 1))
    assert_match("Cloud MTA Build Tool", shell_output("#{bin}mbt --version"))
  end
end