class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghproxy.com/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "88616f34d7cba468bfb1adeb30ff73567db428661b59cbbd39a8716b9f34bd58"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a37f47865f566470765349b597201806bfc8763efcc7d981e4c406494e54d41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fed6d018e6763046624438a00449dcb40f7816ee7eb9066845686f80d78d308f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37c084d14af11ae628a4a2c282c994ec3b520122a12ddf9c717e4b9e644fed1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b94a0bf4ec3b211947badaa8db08cb4e0b42d0b9898fceefc662f1d88d69797"
    sha256 cellar: :any_skip_relocation, ventura:        "004da3fafd9ee30f62121dd0484a91224ad04df8c788995ac955fac69014404c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd1774c92aab5cf2b6593daac4fa846abb728265daf7caac521217fc8ba08c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a72459ea03b8aacf0aeeeabc8e0cfaadf6754667e2f347ef2628eb02dcb121"
  end

  # Uses a hardcoded list of supported JDKs. Try switching to `openjdk` on update.
  depends_on "openjdk@17"

  def install
    system "./gradlew", "micronaut-cli:assemble", "-x", "test"

    mkdir_p libexec/"bin"
    mv "starter-cli/build/exploded/bin/mn", libexec/"bin/mn"
    mv "starter-cli/build/exploded/lib", libexec/"lib"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("17")
  end

  test do
    system "#{bin}/mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end