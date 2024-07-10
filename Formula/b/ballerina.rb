class Ballerina < Formula
  desc "Programming Language for Network Distributed Applications"
  homepage "https://ballerina.io"
  url "https://dist.ballerina.io/downloads/2201.9.2/ballerina-2201.9.2-swan-lake.zip"
  sha256 "a45119e1cec7dc6cd3fbcdc8b118373a53f98aab9a763cd279eea9adff5f1a59"
  license "Apache-2.0"

  # The Downloads and Installation Options pages don't include any version
  # information or download links in the HTML. This information is instead
  # found in page-specific JavaScript files but those use a unique cache-busting
  # hash in the file name. In this scenario, we would have to fetch the page,
  # find the JS file name in the HTML, and fetch the JS file to identify the
  # version. To avoid that setup, we identify the version information from the
  # release notes URL on the Downloads page (though it's a less ideal check).
  livecheck do
    url "https://ballerina.io/downloads/"
    regex(%r{href=.*?release-notes/[^/]*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e49712e35a55e28480fb34453bfcc203df5a1478d4e4e98951ae7bb55e00477"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e49712e35a55e28480fb34453bfcc203df5a1478d4e4e98951ae7bb55e00477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e49712e35a55e28480fb34453bfcc203df5a1478d4e4e98951ae7bb55e00477"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e49712e35a55e28480fb34453bfcc203df5a1478d4e4e98951ae7bb55e00477"
    sha256 cellar: :any_skip_relocation, ventura:        "3e49712e35a55e28480fb34453bfcc203df5a1478d4e4e98951ae7bb55e00477"
    sha256 cellar: :any_skip_relocation, monterey:       "3e49712e35a55e28480fb34453bfcc203df5a1478d4e4e98951ae7bb55e00477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa8ab93a6baf251425b740fae90a9fb6e0e27363fcc9d73a852194f3457f9ed"
  end

  depends_on "openjdk"

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    chmod 0755, "bin/bal"

    bin.install "bin/bal"
    libexec.install Dir["*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina/io;
      public function main() {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/bal run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end