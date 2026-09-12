class Micronaut < Formula
  desc "Modern JVM-based framework for building modular microservices"
  homepage "https://micronaut.io/"
  url "https://ghfast.top/https://github.com/micronaut-projects/micronaut-starter/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "badc9e138949c36176df0ea29e68519dcfc33e85b71946a822ec958deb0f3742"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c40bd46f5f8d31a67255b1bb329c2baca89344a7f4e9ff4a2c14e9230064e944"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "de499718cdb99c4b1da4f5c071cde4cb55139701393dd0498a22cf478c2b7450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97f28236843bf4748cea59d384888ade211afba3418eba89aacd5b6af9afdafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6c9a3a587b38e9e19d7671399df1c879e60fa956d25198ea07b5921769b16eda"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c679c5df0a119ba28915685c0dd31c1620bdcd24aac1627d62fe18fda7db262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2983386003a495f7c3a135ef3b95e02fa0bc758990b928cd1afad5579a57c633"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@25"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("25")
    system "gradle", "micronaut-cli:assemble", "--exclude-task", "test", "--no-daemon"

    libexec.install "starter-cli/build/exploded/lib"
    (libexec/"bin").install "starter-cli/build/exploded/bin/mn"

    bash_completion.install "starter-cli/build/exploded/bin/mn_completion" => "mn"
    (bin/"mn").write_env_script libexec/"bin/mn", Language::Java.overridable_java_home_env("25")
  end

  test do
    system bin/"mn", "create-app", "hello-world"
    assert_predicate testpath/"hello-world", :directory?
  end
end