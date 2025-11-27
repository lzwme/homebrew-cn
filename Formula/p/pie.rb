class Pie < Formula
  desc "PHP Installer for Extensions"
  homepage "https://github.com/php/pie"
  url "https://ghfast.top/https://github.com/php/pie/releases/download/1.3.0/pie.phar"
  sha256 "0eaaed5d49534d5eb53cae637843035ed3e0b9957ebad8521f13717b06480bfc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d33bbff3177340ef4fae9c151f5378ab929be7317879cdccb090901b66ddb07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d33bbff3177340ef4fae9c151f5378ab929be7317879cdccb090901b66ddb07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d33bbff3177340ef4fae9c151f5378ab929be7317879cdccb090901b66ddb07"
    sha256 cellar: :any_skip_relocation, sonoma:        "7be37ca37efa285ca84385e72bb1f7b523ebe92ed1cc5719684e45875364f1ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7be37ca37efa285ca84385e72bb1f7b523ebe92ed1cc5719684e45875364f1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7be37ca37efa285ca84385e72bb1f7b523ebe92ed1cc5719684e45875364f1ba"
  end

  depends_on "php"

  def install
    bin.install "pie.phar" => "pie"
    generate_completions_from_executable("php", bin/"pie", "completion")
  end

  test do
    system bin/"pie", "build", "apcu/apcu"
  end
end