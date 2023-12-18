class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.48.0.tar.gz"
  sha256 "da769e645a053980159e5b247bae92f99d320977fcf5681c7dbcc6f1e9e84109"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0300bccfe5036402445750a9548d07852adda0a309b952463c41665b6bf7c55a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4b050b4e202d378a06aaf37ae6b002d349c48efa2a4b492ee302ba99017d317"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81e4b17567374f5d42765ec9cf2c78fe9d05b5c187ff62e7247b0c538415fcbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc6313a98a9ddcf58445538477da661a4605edf7c0a5bed3c7a234920beebe49"
    sha256 cellar: :any_skip_relocation, ventura:        "e44c000d8d3e646ed5b4a697abe8042e8015535124beb532e41727b5b22dd18f"
    sha256 cellar: :any_skip_relocation, monterey:       "b89f12c36551dcf0fba54d2160b53d3851efe267096796013c303be1b9950da7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14e6189957407ff07aa29334c56b1dfe24bebf5fee75b11dcec08bd338f48e9c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"k6", "completion")
  end

  test do
    (testpath"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}k6 version")
  end
end